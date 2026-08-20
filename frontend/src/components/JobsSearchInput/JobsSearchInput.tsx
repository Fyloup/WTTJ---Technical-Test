import { Select } from "welcome-ui/Select";
import { JobFilterOptions, JobSearchParams } from "../../types";
import SearchIncon from '../../assets/icons/search.svg'

import styles from './JobsSearchInput.module.css'
import { useEffect, useRef, useState } from "react";
import { CONTRACT_TYPE_VALUES, optionsToValuesConverter, STATUS_VALUES, WORK_MODE_VALUES } from "./utils";

type JobsSearchInputProps = {
  filterOptions?: JobFilterOptions;
  debounceMs?: number;
  onSearch: (params: JobSearchParams) => void;
}

export function JobsSearchInput({filterOptions, debounceMs = 200, onSearch}: JobsSearchInputProps) {

    const [title, setTitle] = useState("");
    const [contractType, setContractType] = useState("");
    const [workMode, setWorkMode] = useState("");
    const [office, setOffice] = useState("");
    const [status, setStatus] = useState("");

    const inputRef = useRef<HTMLInputElement>(null)

    function handleOnInputContainerClick() {

        const input = inputRef.current

        if (!input)
            return

        input.focus()
    }

    useEffect(() => {

        const timeoutId = setTimeout(() => {
            onSearch({
                title: title,
                contract_type: contractType,
                work_mode: workMode,
                office: office,
                status: status,
            });
        }, debounceMs);

        return (() => {
            clearTimeout(timeoutId)
        })
    }, [title, contractType, workMode, office, status])

    return (
        <div className={styles.root}>

            {/* Search input */}
            <div className={styles.inputContainer} onClick={handleOnInputContainerClick}>
                <img className={styles.searchIcon} src={SearchIncon} alt="search" />
                <input
                    className={styles.input}
                    ref={inputRef}
                    placeholder="Search by job title…"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                />
            </div>

            {/* Filters */}
            <div className={styles.filtersWrapper}>
                <div className={styles.filterContainer}>
                    <span>
                        Contract Type
                    </span>
                    <Select
                        name="contract_type"
                        placeholder="Contract type"
                        value={contractType}
                        options={optionsToValuesConverter(
                            filterOptions?.contract_types ?? [],
                            CONTRACT_TYPE_VALUES,
                        )}
                        onChange={(value) => setContractType(String(value ?? ""))}
                    />
                </div>
                <div className={styles.filterContainer}>
                    <span>
                        Work Mode
                    </span>
                    <Select
                        name="work_mode"
                        placeholder="Work mode"
                        value={workMode}
                        options={optionsToValuesConverter(filterOptions?.work_modes ?? [], WORK_MODE_VALUES)}
                        onChange={(value) => setWorkMode(String(value ?? ""))}
                    />
                </div>
                <div className={styles.filterContainer}>
                    <span>
                        Location
                    </span>
                    <Select
                        name="office"
                        placeholder="Location"
                        value={office}
                        options={optionsToValuesConverter(filterOptions?.offices ?? [])}
                        onChange={(value) => setOffice(String(value ?? ""))}
                    />
                </div>
                <div className={styles.filterContainer}>
                    <span>
                        Status
                    </span>
                    <Select
                        name="status"
                        placeholder="Status"
                        value={status}
                        options={optionsToValuesConverter(filterOptions?.statuses ?? [], STATUS_VALUES)}
                        onChange={(value) => setStatus(String(value ?? ""))}
                    />
                </div>
            </div>
        </div>
    )
}