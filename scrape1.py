from selenium import webdriver
import pandas as pd

def remove_prefix(text, prefix):
    return text[text.startswith(prefix) and len(prefix):]

n_job=0
IT_job_titles = pd.DataFrame(columns = ['title'])
driver = webdriver.Chrome('chromedriver')
driver.get('http://www.enlightenjobs.com/information-technology-job-titles.php')
for n in range(2, 24):
    header = driver.find_elements_by_xpath('/html/body/div[4]/div[2]/div['+str(n) +']')[0]
    all_children_by_xpath = header.find_elements_by_xpath(".//*")
    for child in all_children_by_xpath:
        text = child.get_attribute('href')
        if text is not None:
            IT_job_titles.loc[n_job]=[remove_prefix(text, 'http://www.enlightenjobs.com/synonyms.php?q=')]
            n_job+=1
IT_job_titles.to_csv('IT_job_titles.csv', index=False)

driver.quit()