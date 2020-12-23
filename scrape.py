from selenium import webdriver
import pandas as pd

data = pd.DataFrame(columns = ['search_title','job_title','required_skills']) 
data_2 = pd.DataFrame(columns = ['search_title','similar_titles', 'similar_skills'])
data.to_csv('job_titles_skills.csv', index=False)
data_2.to_csv('job_titles_similar.csv', index=False)
with open('it_jobs.txt') as f:
    it_jobs = [i.strip() for i in f.readlines()]
n_titles = 0
driver = webdriver.Chrome('chromedriver')
for search_title in it_jobs:
    n_jobs = 0
    driver.get('https://www.dice.com/jobs/q-'+ search_title + '-limit-30-jobs')
    titles_element = driver.find_element_by_xpath('//*[@id="similarSearchesTitle"]')
    similar_titles = titles_element.get_attribute('value')
    skills_element = driver.find_element_by_xpath('//*[@id="similarSearchesSkills"]')
    similar_skills = skills_element.get_attribute('value')
    data_2.loc[n_titles] = [search_title,similar_titles,similar_skills]
    for page in range(1, 3):
        if page != 1:
            driver.get('https://www.dice.com/jobs/q-'+ search_title+ '-limit-100-jobs'+'?p='+ str(page))
        links=[]
        for position in range(0, 30):
            try:
                link_element = driver.find_element_by_xpath('//*[@id="position'+str(position)+'"]')
            except:
                continue
            links.append(link_element.get_attribute('href'))
        
        for link in links:
            driver.get(link)
            try:
                job_title_element = driver.find_element_by_xpath('//*[@id="estJTitle"]')
            except:
                continue
            job_title = job_title_element.get_attribute('value')
            skills = driver.find_element_by_xpath('//*[@id="estSkillText"]')
            required_skills = skills.get_attribute('value')
            data.loc[n_jobs] = [search_title, job_title, required_skills]
            n_jobs+=1
        print('Page completed')
        data.to_csv('job_titles_skills.csv', mode='a', header=False, index=False)
    n_titles+=1
    data_2.to_csv('job_titles_similar.csv', mode='a', header=False, index=False)
    print(search_title + 'completed')
driver.quit()